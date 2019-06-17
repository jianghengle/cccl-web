// initial state
export const state = {
  confirmModal: {
    opened: false,
    title: '',
    message: '',
    button: '',
    callback: null
  },
  loginModal: {
    opened: false
  },
  newFileModal: {
    opened: false,
    callback: null
  },
}

// mutations
export const mutations = {

  openConfirmModal (state, confirm) {
    state.confirmModal.opened = true
    state.confirmModal.title = confirm.title
    state.confirmModal.message = confirm.message
    state.confirmModal.button = confirm.button
    state.confirmModal.callback = confirm.callback
  },

  closeConfirmModal (state) {
    state.confirmModal.opened = false
    state.confirmModal.title = ''
    state.confirmModal.message = ''
    state.confirmModal.button = ''
    state.confirmModal.callback = null
  },

  openLoginModal (state) {
    state.loginModal.opened = true
  },

  closeLoginModal (state) {
    state.loginModal.opened = false
  },

  openNewFileModal (state, context) {
    state.newFileModal.callback = context.callback
    state.newFileModal.opened = true
  },

  closeNewFileModal (state) {
    state.newFileModal.opened = false
    state.newFileModal.callback = null
  },
}

export default {
  namespaced: true,
  state,
  mutations
}
