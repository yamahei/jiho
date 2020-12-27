"use: strinct;";

(function(g){
    const BIT_SUN = 1;
    const BIT_MON = 2;
    const BIT_TUE = 4;
    const BIT_WED = 8;
    const BIT_THU = 16;
    const BIT_FRI = 32;
    const BIT_SAT = 64;

    const state = {
        visible: false,
        toggle: true,
        original: null,
        at: null,
        yobi_sun: null,
        yobi_mon: null,
        yobi_tue: null,
        yobi_wed: null,
        yobi_thu: null,
        yobi_fri: null,
        yobi_sat: null,
        device: null,
        content: null,
    };
    const component = {
        template: `
            <popup :visible="visible">

                <div class="field is-grouped">
                    <p class="control">
                        <input class="input" type="time" v-model="at">
                    </p>
                    <p class="control is-expanded">
                        <label class="checkbox"><input type="checkbox" v-model="yobi_sun" value="1" />日</label>
                        <label class="checkbox"><input type="checkbox" v-model="yobi_mon" value="1" />月</label>
                        <label class="checkbox"><input type="checkbox" v-model="yobi_tue" value="1" />火</label>
                        <label class="checkbox"><input type="checkbox" v-model="yobi_wed" value="1" />水</label>
                        <label class="checkbox"><input type="checkbox" v-model="yobi_thu" value="1" />木</label>
                        <label class="checkbox"><input type="checkbox" v-model="yobi_fri" value="1" />金</label>
                        <label class="checkbox"><input type="checkbox" v-model="yobi_sat" value="1" />土</label>
                    </p>
                    <p class="control">
                        <button class="button" @click="click_toggle">
                            <span class="icon" v-if="toggle"><i class="fa fa-check-square-o"></i></span>
                            <span class="icon" v-if="!toggle"><i class="fa fa-square-o"></i></span>
                        </button>
                    </p>
                </div>
                <div class="field is-grouped">
                    <p class="control">
                        <input class="input" type="text" v-model="device" placeholder="GoogleHome名: 空のとき全部">
                    </p>
                    <p class="control is-expanded">
                        <input class="input" type="text" v-model="content" placeholder="文書 or MP3のURL">
                    </p>
                </div>

                <div class="field is-grouped">
                    <p class="control is-expanded">
                        <button class="button" @click="click_test">Test</button>
                    </p>
                    <p class="control">
                        <button class="button" @click="click_cancel">Cancel</button>
                        <button class="button is-primary" @click="click_ok">OK</button>
                    </p>
                </div>
            </popup>
        `,
        data: function(){
            return state;
        },
        computed: {},
        beforeMount: function(){},
        mounted: function(){},
        methods: {
            click_toggle: function(){
                state.yobi_sun = state.yobi_mon = state.yobi_tue = state.yobi_wed = state.yobi_thu = state.yobi_fri = state.yobi_sat = this.toggle;
                this.toggle = !this.toggle;
            },
            click_cancel: function(){
                state.visible = false;
            },
            click_ok: function(){
                if(false){ return; }//TODO: check
                const yobi = [
                    state.yobi_sun ? "日" : "",
                    state.yobi_mon ? "月" : "",
                    state.yobi_tue ? "火" : "",
                    state.yobi_wed ? "水" : "",
                    state.yobi_thu ? "木" : "",
                    state.yobi_fri ? "金" : "",
                    state.yobi_sat ? "土" : "",
                ].join("");
                param = {
                    original: state.original,
                    item: {
                        at: state.at,
                        yobi: yobi,
                        device: state.device,
                        content: state.content,
                    }
                };
                if(!yobi || !state.content){
                    alert("曜日とコンテンツは必須です");
                }else{
                    state.visible = false;
                    this.$emit("ok", param);
                }
            },
            click_test: function(){
                const device = state.device;
                const content = state.content;
                if(content){
                    const param = {
                        device: device,
                        content: content,
                    }
                    this.$emit("test", param);
                }
            },
        },
    };

    g.Vue.component('modal', component);

    const func = function(){};
    func.prototype.show = function(item){
        if(state.visible){ throw new Error("Modal is shown."); }
        const original = !!Object.keys(item).length ? item : null;
        const yobi = item.yobi || "";
        state.original = item;
        state.at = item.at || "00:00";
        state.yobi_sun = (yobi.indexOf("日") >= 0),
        state.yobi_mon = (yobi.indexOf("月") >= 0),
        state.yobi_tue = (yobi.indexOf("火") >= 0),
        state.yobi_wed = (yobi.indexOf("水") >= 0),
        state.yobi_thu = (yobi.indexOf("木") >= 0),
        state.yobi_fri = (yobi.indexOf("金") >= 0),
        state.yobi_sat = (yobi.indexOf("土") >= 0),
        state.device = item.device || "";
        state.content = item.content || "";
        state.visible = true;
    };

    g.Modal = new func();

})(this);