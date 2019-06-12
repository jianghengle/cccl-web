<template>
  <div id="app">
    <my-header></my-header>
    <div>
      <router-view></router-view>
    </div>
    <my-footer></my-footer>
  </div>
</template>

<script>
import MyHeader from './components/MyHeader'
import MyFooter from './components/MyFooter'

export default {
  name: 'App',
  components: {
    MyHeader,
    MyFooter
  }
}
</script>

<style lang="scss">
@import "~bulma/sass/utilities/initial-variables";
$navbar-height: 84px;
@import "~bulma";
</style>
