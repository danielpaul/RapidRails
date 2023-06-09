import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect () {
    if (localStorage.theme === 'dark' || (!('theme' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
      document.documentElement.classList.add('dark')
    } else {
      document.documentElement.classList.remove('dark')
    }
  }

  darkMode () {
    localStorage.theme = 'dark'
    document.documentElement.classList.add('dark')
  }

  lightMode () {
    localStorage.theme = 'light'
    document.documentElement.classList.remove('dark')
  }
}
