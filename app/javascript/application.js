// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import '@hotwired/turbo-rails'
import 'controllers'

import 'alpine-turbo-drive-adapter'
import Alpine from 'alpinejs'

window.Alpine = Alpine
Alpine.start()
