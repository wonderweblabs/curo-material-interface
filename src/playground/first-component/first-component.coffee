'use strict'

Polymer

  is: 'first-component',

  ready: ->
    @.contacts = [
      {
        name: "Rob",
        email: "rob@email.com",
        img: 'https://randomuser.me/api/portraits/thumb/men/10.jpg'
      },
      {
        name: 'Bob',
        email: 'bob@email.com',
        img: 'https://randomuser.me/api/portraits/thumb/men/9.jpg'
      },
      {
        name: 'Todd',
        email: 'rob@email.com',
        img: 'https://randomuser.me/api/portraits/thumb/men/8.jpg'
      }
    ]
