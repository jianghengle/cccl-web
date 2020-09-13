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
  newFolderModal: {
    opened: false,
    callback: null
  },
  addMenuModal: {
    opened: false,
    parentId: null,
    callback: null
  },
  editMenuModal: {
    opened: false,
    isParent: false,
    id: null,
    name: '',
    index: 0,
    url: '',
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

  openNewFolderModal (state, context) {
    state.newFolderModal.callback = context.callback
    state.newFolderModal.opened = true
  },

  closeNewFolderModal (state) {
    state.newFolderModal.opened = false
    state.newFolderModal.callback = null
  },

  openAddMenuModal (state, context) {
    state.addMenuModal.opened = true
    state.addMenuModal.parentId = context.parentId
    state.addMenuModal.callback = context.callback
  },

  closeAddMenuModal (state, context) {
    state.addMenuModal.opened = false
    state.addMenuModal.parentId = null
    state.addMenuModal.callback = null
  },

  openEditMenuModal (state, context) {
    state.editMenuModal.opened = true
    state.editMenuModal.isParent = context.isParent
    state.editMenuModal.id = context.id
    state.editMenuModal.name = context.name
    state.editMenuModal.index = context.index
    state.editMenuModal.url = context.url
    state.editMenuModal.callback = context.callback
  },

  closeEditMenuModal (state, context) {
    state.editMenuModal.opened = false
    state.editMenuModal.isParent = false
    state.editMenuModal.id = null
    state.editMenuModal.name = ''
    state.editMenuModal.index = ''
    state.editMenuModal.url = ''
    state.editMenuModal.callback = null
  },
}

export default {
  namespaced: true,
  state,
  mutations
}
