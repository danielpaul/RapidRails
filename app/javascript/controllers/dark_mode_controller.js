import { Controller } from '@hotwired/stimulus'
import Cookies from 'js-cookie'

export default class extends Controller {
  connect () {
    if (
      Cookies.get('theme') === 'dark' ||
      (!Cookies.get('theme') &&
        window.matchMedia('(prefers-color-scheme: dark)').matches)
    ) {
      document.documentElement.classList.add('dark')
    } else {
      document.documentElement.classList.remove('dark')
    }
  }

  darkMode () {
    Cookies.set('theme', 'dark', { expires: 7 })
    document.documentElement.classList.add('dark')
  }

  lightMode () {
    Cookies.set('theme', 'light', { expires: 7 })
    document.documentElement.classList.remove('dark')
  }
}
