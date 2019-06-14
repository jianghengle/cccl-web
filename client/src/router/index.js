import Vue from 'vue'
import Router from 'vue-router'
import MyMain from '@/components/MyMain'
import About from '@/components/About'
import Coworkers from '@/components/Coworkers'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'MyMain',
      component: MyMain
    },
    {
      path: '/about',
      name: 'About',
      component: About
    },
    {
      path: '/coworkers',
      name: 'Coworkers',
      component: Coworkers
    },
  ]
})
