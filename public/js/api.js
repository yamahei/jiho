
(function(g){
    "use: strinct;";

    const state = {
        hook: {
            start: null,
            end: null,
            error: null,
        },
    };

    //axios.defaults.baseURL = "http://localhost:4567";
    axios.interceptors.request.use(function (request) {
        state.hook.start && state.hook.start();
        return request;
    }, function (error) {
        state.hook.error && state.hook.error(error);
        state.hook.end && state.hook.end();
        return Promise.reject(error);
    });
    axios.interceptors.response.use(function (response) {
        if(response.request.status == 200){
            state.hook.end && state.hook.end();
            return response;
        }else{
            state.hook.error && state.hook.error(response);
            state.hook.end && state.hook.end();
            return Promise.reject(response);//あってんのかな？
        }
    }, function (error) {
        state.hook.error && state.hook.error(error);
        state.hook.end && state.hook.end();
        return Promise.reject(error);
    });

    // const ADMIN_BASE_URI = "/api/admin";
    // const SYNC_BASE_URI = "/api/sync";
    const TOOLS_BASE_URI = "/api/tools";
    const INSPECT_BASE_URI = "/api/inspect";
    const api = function(){};

    //General
    // api.prototype.set_base_url = function(url){
    //     //ATTENTION: 末尾に"/"いらない
    //     axios.defaults.baseURL = url;
    // };
    api.prototype.set_hooks = function(start, end, error){
        state.hook.start = start;
        state.hook.end = end;
        state.hook.error = error;
    };

    api.prototype.get_list = function(){
        const url = "/list";
        const params = {};
        return axios.get(url, params);
    };
    api.prototype.put_list = function(list){
        const url = "/list";
        const params = { list: list };
        return axios.put(url, params);
    };
    api.prototype.talk = function(device, content){
        const url = "/talk";
        const params = { device: device, content: content };
        return axios.put(url, params);
    };


    g.API = new api();

})(this);