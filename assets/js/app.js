// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let user_id = window.localStorage.getItem("user_id");

let Hooks = {};


function scrollToEnd() {
    setTimeout(() => {
        const messageContainer = document.getElementById('message-container');
        messageContainer.scrollTop = messageContainer.scrollHeight;
    },500);
}

Hooks.FormReset = {
    mounted() {
        this.el.addEventListener("keypress", e => {
            if (e.key === 'Enter') {
                setTimeout(() => {
                    document.getElementById('chat-input').value = '';
                    scrollToEnd()
                }, 500);    
              }
        })
    },
}

Hooks.FormResetByClick = {
    mounted() {
        this.el.addEventListener("click", e => {
            setTimeout(() => {
                document.getElementById('chat-input').value = '';
                scrollToEnd()
            }, 500);    
        })
    },
}

Hooks.GetUserId = {
    mounted() {
        // push event get_user_id
        this.handleEvent("received_user_id", ({user_id}) => {
            window.localStorage.setItem("user_id", user_id);
        });
        if (user_id) {
            this.pushEvent("set_user_id", { user_id: user_id });
        } else {
            this.pushEvent("create_user", { });
        }
    }
}


let liveSocket = new LiveSocket("/live", Socket, {
    params: {_csrf_token: csrfToken, ...(user_id ? {id: user_id} : {})},
    hooks: Hooks
})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())


// connect if there are any LiveViews on the page
liveSocket.connect()


// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

