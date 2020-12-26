require "bundler/setup"
Bundler.require

require 'yaml'
require 'json'

require_relative './lib/jiho'

# server
class MyApp < Sinatra::Base

    CMD_PATH = File.expand_path("../rubycast/bin/googlehome.rb", __FILE__)
    LIST_PATH = File.expand_path("../jiho_list.yaml", __FILE__)
    TIME_FORMAT = /^\d{2}:\d{2}$/
    YOBI_FORMAT = /^日?月?火?水?木?金?土?$/

    # tick
    EM::defer do
        loop do
            begin
                yaml = `cat #{LIST_PATH}` || "[]"
                Jiho.tick YAML.load(yaml)
            rescue=> e
                puts e.full_message
            ensure
                sleep 15
            end
        end
    end

    configure do
        set :bind, '0.0.0.0'
        enable :sessions
        use Rack::JSONBodyParser
        register Sinatra::Validation
        register Sinatra::Namespace
        register Sinatra::Reloader#TODO: not working?
        set :show_exceptions, :after_handler# in development, false or :after_handler
    end
    error 500 do
        p e = env['sinatra.error']
        status 500
        {:message => e.message}.to_json
    end

    #
    # APP
    #
    get /\..+/ do
        404
    end
    get '/' do
        redirect '/index.html'
    end

    get '/list' do
        if FileTest.exist?(LIST_PATH) then
            list = YAML.load_file(LIST_PATH)
            list.to_json
        else
            [].to_json
        end
    end

    put '/list' do
        item_type = Dry::Schema.Params do
            required(:at).filled(:string, format?: TIME_FORMAT)
            required(:yobi).filled(:string, format?: YOBI_FORMAT)
            optional(:device).maybe(:string)
            required(:content).filled(:string)
        end
        validates{ params{
            required(:list).value(:array).each(item_type)
        }}
        list = params[:list].map{|e| e.to_h }#IndifferentHash -> Hash
        yaml = YAML.dump(list)
        File.write(LIST_PATH, yaml)
        200
    end

    put '/talk' do
        validates{ params{
            optional(:device).maybe(:string)
            required(:content).filled(:string)
        }}
        Jiho.talk(params[:device], params[:content])
        200
    end

end


if $0 == __FILE__ then
    MyApp.run! :host => 'localhost'
end

