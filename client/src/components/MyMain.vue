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
    <div class="container schedule-blocks">
      <div class="columns is-multiline">
        <div v-for="s in scheduleBlocks" class="column is-half">
          <div class="card">
            <div class="card-content">
              <block :blockObj="s" :editable="false" :inTable="false"></block>
            </div>
          </div>
        </div>
      </div>
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
      })
    },
    welcomeBlockChanged (obj) {
      this.welcomeBlock.content = obj.content
    },
    requestRecentSchedule () {
      this.$http.get(xHTTPx + '/get_recent_schedule_blocks').then(response => {
        this.scheduleBlocks = response.body.sort(function(a, b){
          return a.time - b.time
        })
      })
    },
  },
  mounted () {
    this.windowWidth = window.innerWidth
    this.slideWidth = document.getElementById('slides-container').offsetWidth
    window.addEventListener('resize', this.handleResize)

    this.requestWelcomeBlock()
    this.requestRecentSchedule()
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

.schedule-blocks {
  margin-top: 100px;
  margin-bottom: 50px;
  padding-left: 10px;
  padding-right: 10px;
}

</style>
