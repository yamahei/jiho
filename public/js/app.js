"use: strinct;";

(function(g){

/**
 * Hooks
 */
const loader_func = g.get_loader_func();
const api_start = function(){
    state.loader_visible = loader_func.show_loader();
};
const api_end = function(){
    state.loader_visible = loader_func.hide_loader();
};
const api_error = function(error){
    console.log(error);
    const message = (error?.response?.data?.message || error?.message || error);
    g.alert(message);
    state.loader_visible = loader_func.abort_loader();
};

/**
 * Routes
 */
const router = new VueRouter({
    routes: [
        { path: '/', redirect: { name: g.work_name }},
        { name: g.work_name, path: g.work_path, component: g.work_page },
    ],
});
/**
 * Main
 */
const state = {
    loader_visible: false,
    page_junme: null,
};
g.STATE = state;
const main_page = {
    router: router,
    el: '#app',
    data: state,
    computed: {},
    beforeMount: function(){},
    mounted: function(){},
    methods: {
        /**
         * From Page
         */

        /**
         * Paging
         */
        show_work_page: function(){
            this.show_a_page(g.work_name, {});
        },
        show_list_page: function(junme){
            this.show_a_page(g.list_name, { junme: junme });
        },
        on_back() {
            if(g.window.history.length > 1){
                this.$router.go(-1);
            }else{
                this.$router.push('/');
            }
        }
    },
};
g.window.addEventListener('load', function(){
    g.API.set_hooks(api_start, api_end, api_error);
    const app = new Vue(main_page);
});

})(this);