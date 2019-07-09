import Vue from 'vue'
import Router from 'vue-router'
import MyMain from '@/components/MyMain'
import About from '@/components/About'
import Coworkers from '@/components/Coworkers'
import Files from '@/components/Files'
import File from '@/components/File'
import Blogs from '@/components/Blogs'
import NewBlog from '@/components/NewBlog'
import Blog from '@/components/Blog'

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
    {
      path: '/files',
      name: 'RootFiles',
      component: Files
    },
    {
      path: '/files/:path',
      name: 'Files',
      component: Files
    },
    {
      path: '/file/:id',
      name: 'File',
      component: File
    },
    {
      path: '/blogs',
      name: 'Blogs',
      component: Blogs
    },
    {
      path: '/new-blog',
      name: 'NewBlog',
      component: NewBlog
    },
    {
      path: '/blog/:id',
      name: 'Blog',
      component: Blog
    },
  ],
  scrollBehavior (to, from, savedPosition) {
    if(to.name == 'Blog')
      return {x: 0, y: 0}
    if(savedPosition)
      return savedPosition
    return {x: 0, y: 0}
  }
})
