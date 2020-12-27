class SearchGoogleHome

    # $ avahi-browse _googlecast._tcp -rt | grep -E "^(=|\s)"
    # = enp2s0 IPv4 Google-Home-Mini-99f3c58bf3471cc10cd87f79d33599cf _googlecast._tcp     local
    #    hostname = [99f3c58b-f347-1cc1-0cd8-7f79d33599cf.local]
    #    address = [192.168.1.2]
    #    port = [8009]
    #    txt = ["rs=" "nf=1" "bs=FA8FCA7B4DCD" "st=0" "ca=198660" "fn=ファミリー ルーム" "ic=/setup/icon.png" "md=Google Home Mini" "ve=05" "rm=34432AD6C4E19CD9" "cd=56AED3E829D7ACE11EED6FDAA059A193" "id=99f3c58bf3471cc10cd87f79d33599cf"]
    # = enp2s0 IPv4 Google-Home-Mini-7ab9edb8fbd867f7eb76bf253a94e423 _googlecast._tcp     local
    #    hostname = [7ab9edb8-fbd8-67f7-eb76-bf253a94e423.local]
    #    address = [192.168.1.5]
    #    port = [8009]
    #    txt = ["rs=" "nf=1" "bs=FA8FCA6F4104" "st=0" "ca=198660" "fn=ベッドルーム" "ic=/setup/icon.png" "md=Google Home Mini" "ve=05" "rm=95FDEFFAC7D34ABD" "cd=55FCA9BD8DEA293B19F0EDA067B5B103" "id=7ab9edb8fbd867f7eb76bf253a94e423"]
    
    # option -t: 表示後にコマンドを終了させる
    # option -r: 表示後にコマンドを終了させる
    

    def self.scan
        # 
        # check platform
        # 
        if RUBY_PLATFORM.downcase =~ /mswin(?!ce)|mingw|cygwin|bccwin/
            raise RuntimeError.new("Windows未対応のプログラムです")
        end

        # 
        # search google home
        # 
        begin
            results = `avahi-browse _googlecast._tcp -rt | grep -E "^(=|\s)"`
        rescue => e
            # How to install(Raspberry pi)
            # $ sudo apt-get install avahi-daemon libnss-mdns avahi-utils 
            raise RuntimeError.new("avahi-browse実行中のエラー")
        end

        # 
        # parse result
        # 
        google_homes = []
        current = nil
        results.each_line{|line|
            if line =~ /^=/ then
                google_homes.push(current) if current
                current = {}
            elsif line =~ /^\s/ then
                all, key, value = *line.match(/\s+(\w+)\s*=\s*\[(.+)\]/)
                if key != "txt" then
                    current[key] = value
                else
                    value.scan(/\w+=[^"\]]+/){|part|
                        subkey, subvalue = *part.split("=")
                        current[subkey] = subvalue if subvalue && !subvalue.empty?
                    }
                end
            end
        }
        google_homes.push(current) if current

        # 
        # output
        # 
        google_homes
    end
end

if __FILE__ == $0 then
    require "json"
    puts SearchGoogleHome.scan.to_json
end
