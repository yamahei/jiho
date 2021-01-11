"use: strinct;";

(function(g){

/** work */
const work_name = g.work_name = "work_page"
const work_path = g.work_path = "/work"
const work_page = g.work_page = {
    template: '#WORK_PAGE_TEMPLATE',
    data: function(){
        return {
            list: [/*
                { at, yobi, devicwe, content }
            */]
            // 日月火水木金土
        };
    },
    computed: {
    },
    beforeMount: function(){
        const self = this;
        g.API.get_list().then(function(response){
            const list = response.data || [];
            self.list.splice(0);
            self.list.push(...Util.sort(list, ["at", "yobi"]));
            if(self.list.length <= 0){
                self.list.push({
                    at: "00:00",
                    yobi: "日月火水木金土",
                    device: "",
                    content: "sample",
                });
            }
        });
    },
    mounted: function(){
    },
    methods: {
        on_click_delete: function(item){
            message = [
                "時報を削除しますか？",
                `　時刻：${item.at}`,
                `　曜日：${item.yobi}`,
                `　内容：${item.content}`,
            ].join("\n");
            if(confirm(message)){
                const index = this.list.indexOf(item);
                if(index >= 0){
                    this.list.splice(index, 1);
                }
            }
        },
        on_click_edit: function(item){
            g.Modal.show(item);
        },
        on_click_append: function(){
            g.Modal.show({});
        },
        on_modal_ok: function($event){
            const original = $event.original;
            const item = $event.item;
            if(!Object.keys(original).length){//append
                this.list.push($event.item);
            }else{//edit
                original.at = item.at;
                original.yobi = item.yobi;
                original.device = item.device;
                original.content = item.content;
            }
            console.log(Util.sort(this.list, ["at", "yobi"]));
        },
        on_modal_test: function($event){
            const device = $event.device;
            const content = $event.content;
            if(content){
                g.API.talk(device, content);
            }
        },
        on_click_save: function(){
            const message = "保存します";
            if(confirm(message)){
                g.API.put_list(this.list).then(function(response){
                    g.location.reload();
                });
            }
        },
    },
};
})(this);