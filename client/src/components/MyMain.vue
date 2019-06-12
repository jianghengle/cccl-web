<template>
  <div>
    <div>
      <div class="container">
        <div id="slides-container" class="slides-container" :style="{'height': slideHeight+'px'}">
          <a class="button is-large is-white slide-left" :style="{'top': angleTop+'px'}">
            <v-icon class="icon has-text-grey-lighter" name="angle-left"/>
          </a>
          <a class="button is-large is-white slide-right" :style="{'top': angleTop+'px'}">
            <v-icon class="icon has-text-grey-lighter" name="angle-right"/>
          </a>
          <div>
            slide
          </div>
        </div>
      </div>
    </div>
    <div class="container">
      text block{{windowWidth}},{{slideWidth}}
    </div>
  </div>
</template>

<script>

export default {
  name: 'my-main',
  data () {
    return {
      windowWidth: 0,
      slideWidth: 0
    }
  },
  computed: {
    slideHeight () {
      return this.windowWidth > 600 ? 600 : 300
    },
    angleTop () {
      return this.windowWidth > 600 ? 280 : 130
    }
  },
  methods: {
    handleResize () {
      this.windowWidth = window.innerWidth
      this.slideWidth = document.getElementById('slides-container').offsetWidth
    }
  },
  mounted () {
    this.windowWidth = window.innerWidth
    this.slideWidth = document.getElementById('slides-container').offsetWidth
    window.addEventListener('resize', this.handleResize)
  },
  beforeDestroy () {
    window.removeEventListener('resize', this.handleResize)
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style lang="scss" scoped>

.slides-container {
  width: 100%;
  position: relative;

  .slide-left {
    z-index: 10;
    position: absolute;
    top: 260px;
    cursor: pointer;
  }

  .slide-right {
    z-index: 10;
    position: absolute;
    top: 260px;
    right: 0px;
    cursor: pointer;
  }
}

</style>
