// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'
import store from './store'
import VueResource from 'vue-resource'
Vue.use(VueResource)

import 'vue-awesome/icons/sign-in-alt'
import 'vue-awesome/icons/sign-out-alt'
import 'vue-awesome/icons/angle-left'
import 'vue-awesome/icons/angle-right'
import 'vue-awesome/icons/chevron-up'
import 'vue-awesome/icons/chevron-down'
import 'vue-awesome/icons/chevron-left'
import 'vue-awesome/icons/spinner'
import 'vue-awesome/icons/edit'
import 'vue-awesome/icons/upload'
import Icon from 'vue-awesome/components/Icon'
Vue.component('v-icon', Icon)

Vue.config.productionTip = false

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  store,
  components: { App },
  template: '<App/>'
})
