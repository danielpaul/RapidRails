const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  darkMode: 'class',
  content: [
    './app/views/**/*.rb',
    './app/components/**/*rb',
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
    './app/helpers/tailwind_form_builder.rb'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans]
      },
      colors: {
        primary: {
          DEFAULT: '#007aff',
          500: '#0077ed'
        },

        body: {
          DEFAULT: '#f5f5f7',
          dark: '#000000'
        },

        card: {
          DEFAULT: '#ffffff',
          dark: '#18171c'
        }
      },
      fontSize: {
        base: '0.9rem'
      }
    }
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries')
  ]
}
