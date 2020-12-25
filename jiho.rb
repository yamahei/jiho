require 'date'
require 'time'

class Jiho

    @@last = nil
    @@list = []

    def self.set_cmd_path cmd_path
        @@cmd_path = cmd_path
    end
    def self.set_list list
        @@list = list
    end
    def self.tick list=@@list
        now = Time.now.strftime("%H:%M")
        yobi = %w(日 月 火 水 木 金 土)[Date.today.wday]
        return if @@last == now
        @@last = now

        list.select{|item|
            item["at"] == now
        }.select{|item|
            item["yobi"].include?(yobi)
        }.each{|item|
            talk(item["device"], item["content"])
        }
    end
    def self.talk device, content
        dq ='"'
        cmd = [
            "bundle exec ruby -I lib",
            @@cmd_path,
            "--text=#{dq}#{content}#{dq}",
        ]
        if device && !device.empty? then
            cmd.push("--name=#{dq}#{}#{dq}")
        end
        p cmd
        p `#{cmd.join(" ")} &`
    end
end

