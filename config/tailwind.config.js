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
    './app/helpers/rapidrails_form_builder.rb'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans]
      },
      colors: {
        primary: {
          DEFAULT: '#007aff',
          500: '#0077ed',
          600: '#006edb'
        },

        body: {
          DEFAULT: '#fafafa',
          dark: '#010409'
        },

        card: {
          DEFAULT: '#ffffff',
          dark: '#18171c'
        },

        neutral: {
          750: '#38383d'
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
