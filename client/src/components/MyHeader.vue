<template>
  <div>
    <nav class="navbar has-shadow is-link">
      <div class="container">
        <div class="navbar-brand">
          <router-link class="navbar-item has-text-weight-bold" :to="'/'">
            林肯华人基督教会 CCCL
          </router-link>
          <div class="navbar-burger burger app-burger" :class="{'is-active': menuActive}"
            @click="menuActive = !menuActive">
            <span></span>
            <span></span>
            <span></span>
          </div>
        </div>
        <div class="navbar-menu" :class="{'is-active': menuActive}">
          <div class="navbar-start">
            <router-link class="navbar-item" :to="'/about'">
              我们 About Us
            </router-link>
            <router-link class="navbar-item" :to="'/blogs'">
              动态 Blogs
            </router-link>
            <router-link class="navbar-item" :to="'/coworkers'">
              同工 Work
            </router-link>

            <div class="navbar-item has-dropdown is-hoverable" v-for="mg in otherMenus" :key="mg.parent.id">
              <a class="navbar-link" :href="mg.parent.url ? mg.parent.url : mg.parent.path">
                <span v-if="token" @click.stop.prevent="editMenu(mg.parent, true)"><v-icon name="ellipsis-v" class="my-menu-icon"/></span>
                <span>{{mg.parent.name}}{{mg.children.length}}</span>
              </a>

              <div class="navbar-dropdown" v-if="mg.children.length || token">
                <a class="navbar-item" v-for="mt in mg.children" :href="mt.url ? mt.url : mt.path" :key="mt.id">
                  <span v-if="token" @click.stop.prevent="editMenu(mt, false)"><v-icon name="ellipsis-v" class="my-menu-icon"/></span>
                  <span>{{mt.name}}</span>
                </a>
                <hr class="navbar-divider" v-if="mg.children.length && token">
                <a class="navbar-item" v-if="token" @click="addMenu(mg.parent.id)">
                  <v-icon name="plus" class="my-menu-icon"/>&nbsp;Add
                </a>
              </div>
            </div>

            <a class="navbar-item" v-if="token" @click="addMenu(null)">
              <v-icon name="plus" class="my-menu-icon"/>
            </a>
          </div>

          <div class="navbar-end">
            <router-link  class="navbar-item" :to="'/files'">
              文件 Files
            </router-link>
            <a class="navbar-item" v-if="!token" @click="login">
              <v-icon name="user"/>
            </a>
            <a class="navbar-item" v-if="token" @click="logout">
              <v-icon name="user"/>
            </a>
          </div>
        </div>
      </div>
    </nav>
  </div>
</template>

<script>
import Vue from 'vue'

export default {
  name: 'my-header',
  data () {
    return {
      menuActive: false,
      otherMenus: []
    }
  },
  computed: {
    token () {
      return this.$store.state.user.token
    }
  },
  methods: {
    login () {
      this.$store.commit('modals/openLoginModal')
    },
    logout () {
      var confirm = {
        title: 'Logout',
        message: 'Are you sure to logout?',
        button: 'Yes, I am sure.',
        callback: {
          context: this,
          method: this.logoutConfirmed,
          args: []
        }
      }
      this.$store.commit('modals/openConfirmModal', confirm)
    },
    logoutConfirmed () {
      delete Vue.http.headers.common['Authorization']
      this.$store.commit('user/reset')
    },
    requestMenus () {
      this.$http.get(xHTTPx + '/get_all_menus').then(response => {
        var vm = this
        this.otherMenus = response.body.map(function(group){
          var parent = vm.makeMenuItem(group[0])
          var children = group.slice(1).map(vm.makeMenuItem)
          return {parent: parent, children: children}
        })
      })
    },
    makeMenuItem (m) {
      return {
        id: m.id,
        name: m.name,
        index: m.menuIndex,
        url: m.link,
        path: '#/page/' + m.blockId
      }
    },
    addMenu (parentId) {
      var obj = {
        parentId: parentId,
        callback: {
          context: this,
          method: this.requestMenus,
          args: []
        }
      }
      this.$store.commit('modals/openAddMenuModal', obj)
    },
    editMenu (menu, isParent) {
      var obj = {
        isParent: isParent,
        id: menu.id,
        name: menu.name,
        index: menu.index,
        url: menu.url,
        callback: {
          context: this,
          method: this.requestMenus,
          args: []
        }
      }
      this.$store.commit('modals/openEditMenuModal', obj)
    }
  },
  mounted () {
    if(this.token) {
      Vue.http.headers.common['Authorization'] = this.token
    }
    this.requestMenus()
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style lang="scss" scoped>
.my-menu-icon {
  height: 12px;
  width: 12px;
  margin-right: 5px;
}
</style>
