<template>
  <div id="app">
    <my-header></my-header>
    <div>
      <router-view></router-view>
    </div>
  </div>
</template>

<script>
import MyHeader from './components/MyHeader'

export default {
  name: 'App',
  components: {
    MyHeader
  }
}
</script>

<style lang="scss">
@import "~bulma/sass/utilities/initial-variables";
$navbar-height: 84px;
@import "~bulma";
</style>
