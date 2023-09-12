import '../active_admin/jquery'
import 'jquery-ui'
import 'jquery-ui/ui/widgets/mouse'
import '@activeadmin/activeadmin'
import "activeadmin_addons"
import "@fortawesome/fontawesome-free/css/all.css";
import 'arctic_admin'
import { createApp } from 'vue';
import AdminComponent from '../components/admin-component.vue';

function onLoad() {
  if (document.getElementById('wrapper') !== null) {
    const app = createApp({
      mounted() {
        // We need to re-trigger DOMContentLoaded for ArcticAdmin after Vue replaces DOM elements
        window.document.dispatchEvent(new Event('DOMContentLoaded', {
          bubbles: true,
          cancelable: true,
        }));
      },
    });
    app.component('admin_component', AdminComponent);

    // Avoid using '#wrapper' as the mount point, as that includes the entire admin page,
    // which could be used for Client-Side Template Injection (CSTI) attacks. Limit the
    // mount point to specific areas where you need Vue components.

    // DO NOT mount Vue in elements that contain user input rendered by
    // ActiveAdmin.
    // By default ActiveAdmin doesn't escape {{ }} in user input, so it's
    // possible to inject arbitrary JavaScript code into the page.

    // app.mount('#wrapper');
  }

  return null;
}

document.addEventListener('DOMContentLoaded', onLoad, { once: true });
