<template>
  <div>
    <div class="container my-page" v-if="aboutBlock || contactBlock">
      <div class="about-block" v-if="aboutBlock">
        <block :blockObj="aboutBlock" :editable="true" :inTable="false" @blockChanged="aboutBlockChanged"></block>
      </div>
      <div class="contact-block" v-if="contactBlock">
        <block :blockObj="contactBlock" :editable="true" :inTable="false" @blockChanged="contactBlockChanged"></block>
      </div>
    </div>
  </div>
</template>

<script>
import Block from './Block'

export default {
  name: 'about',
  components: {
    Block
  },
  data () {
    return {
      aboutBlock: null,
      contactBlock: null
    }
  },
  methods: {
    aboutBlockChanged (obj) {
      this.aboutBlock.content = obj.content
    },
    contactBlockChanged (obj) {
      this.contactBlock.content = obj.content
    }
  },
  mounted () {
    this.$http.post(xHTTPx + '/get_block_by_name', {name: 'About Us'}).then(response => {
      this.aboutBlock = response.body
    })

    this.$http.post(xHTTPx + '/get_block_by_name', {name: 'Contact Us'}).then(response => {
      this.contactBlock = response.body
    })
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style lang="scss" scoped>

.about-block {
  margin-top: 50px;
  margin-bottom: 20px;
  padding-left: 10px;
  padding-right: 10px;
}

.contact-block {
  margin-top: 50px;
  margin-bottom: 50px;
  padding-left: 10px;
  padding-right: 10px;
}

</style>
