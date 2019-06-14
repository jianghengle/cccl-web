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
            
          </div>
        </div>
      </div>
    </div>
    <div class="container welcome-block" v-if="welcomeBlock">
      <block :blockObj="welcomeBlock" :editable="true" :inTable="false" @blockChanged="welcomeBlockChanged"></block>
    </div>
  </div>
</template>

<script>
import Block from './Block'

export default {
  name: 'my-main',
  components: {
    Block
  },
  data () {
    return {
      windowWidth: 0,
      slideWidth: 0,
      welcomeBlock: null,
      scheduleBlocks: []
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
    },
    requestWelcomeBlock () {
      this.$http.post(xHTTPx + '/get_block_by_name', {name: 'Welcome!'}).then(response => {
        this.welcomeBlock = response.body
      }, response => {
        this.error = 'Failed to get block!'
      })
    },
    welcomeBlockChanged (obj) {
      this.welcomeBlock.content = obj.content
    }
  },
  mounted () {
    this.windowWidth = window.innerWidth
    this.slideWidth = document.getElementById('slides-container').offsetWidth
    window.addEventListener('resize', this.handleResize)

    this.requestWelcomeBlock()
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

.welcome-block {
  margin-top: 20px;
  margin-bottom: 20px;
  padding-left: 10px;
  padding-right: 10px;
}

</style>
