<template>
  <div>
    <footer class="footer my-footer">
      <div class="container">
        <div class="content has-text-centered footer-text">
          <p>
            <span class="has-text-weight-bold">地址: </span> 在13街和K街十字路口西北角, 聚会地点在地下一层，请由建筑后门进入。<br />
            <span class="has-text-weight-bold">Address: </span> First Baptist Church, 1340 K St. Lincoln, NE 68508
          </p>
        </div>
      </div>
    </footer>
  </div>
</template>

<script>
export default {
  name: 'my-footer',
  data () {
    return {
      msg: 'Welcome to Your Vue.js App'
    }
  }
}
</script>

<style lang="scss" scoped>

.my-footer {
  background-color: #250d3c;

  .footer-text {
    color: white;
  }
}


</style>
