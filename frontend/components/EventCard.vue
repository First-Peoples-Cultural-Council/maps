<template>
  <div class="event-list-container">
    <template v-if="finalListOfEvents.length !== 0">
      <div
        v-for="event in finalListOfEvents"
        :key="event.id"
        class="event-card-container"
        @click="redirectToEvent(event.properties.name)"
      >
        <img class="event-img" :src="getEventImg(event.properties.image)" />
        <div class="event-details">
          <span class="event-date">{{
            getDate(event.properties.related_data)
          }}</span>
          <span
            class="event-date-description"
            :class="getDateStatus(event.properties.related_data)"
            >{{ getDateValue(event.properties.related_data) }}</span
          >
          <h4 class="event-title">{{ event.properties.name }}</h4>
          <div class="events-tags-container">
            <span
              v-for="taxonomy in event.properties.taxonomies"
              :key="taxonomy.name"
              @click.stop.prevent="redirectToFilter(taxonomy.name)"
              >{{ taxonomy.name }}</span
            >
          </div>
        </div>
      </div>
    </template>
    <div v-else class="event-card-container">
      <div class="no-event-container">
        <img src="@/assets/images/event_icon.svg" class="menu-icon" />
        <h4 class="event-title">There are no upcoming Events</h4>
      </div>
    </div>
  </div>
</template>

<script>
import { getMediaUrl, encodeFPCC, getApiUrl } from '@/plugins/utils.js'

export default {
  computed: {
    hasDateList() {
      return this.$store.state.arts.eventsSet.filter(event => {
        const hasEventDate = this.findEventDateInRD(
          event.properties.related_data
        )

        return !!hasEventDate
      })
    },
    upcomingEventList() {
      return this.hasDateList.filter(event => {
        const findEventDate = this.findEventDateInRD(
          event.properties.related_data
        )

        const eventDate = new Date(findEventDate.value)
        if (eventDate > Date.now()) {
          const resultDate = eventDate - Date.now()
          const differenceInDays = Math.ceil(resultDate / (1000 * 60 * 60 * 24))
          if (differenceInDays <= 10) {
            return true
          }
        }
      })
    },
    finishedEventList() {
      return this.hasDateList.filter(event => {
        const findEventDate = this.findEventDateInRD(
          event.properties.related_data
        )

        const eventDate = new Date(findEventDate.value)
        if (eventDate < Date.now()) {
          const resultDate = eventDate - Date.now()
          const differenceInDays = Math.ceil(resultDate / (1000 * 60 * 60 * 24))
          if (differenceInDays <= 7) {
            return true
          }
        }
      })
    },
    finalListOfEvents() {
      return [
        ...this.sortedEventDates(this.upcomingEventList, 'desc'),
        ...this.sortedEventDates(this.finishedEventList, 'asc')
      ]
    }
  },
  async mounted() {
    const result = await this.$axios.$get(getApiUrl('arts/event'))
    if (result) {
      this.$store.commit('arts/setNextEvents', result.features)
    }
  },
  methods: {
    getEventImg(img) {
      return img ? getMediaUrl(img) : require(`@/assets/images/event_icon.svg`)
    },
    redirectToEvent(name) {
      this.resetState()
      this.$router.push({
        path: `/art/${encodeFPCC(name)}`
      })
    },
    redirectToFilter(taxonomy) {
      this.resetState()
      this.$root.$emit('resetMap')
      this.$store.commit('arts/setFilter', 'event')
      this.$store.commit('arts/setTaxonomyTag', [taxonomy])
      this.$root.$emit('triggerLoadKindData')
      this.$router.push({
        path: '/art'
      })
    },
    resetState() {
      this.$store.commit('sidebar/setDrawerContent', false)
      this.$root.$emit('closeEventPopover')
      this.$root.$emit('toggleEventOverlay', false)
    },
    getDate(relatedData) {
      const findDate = this.findEventDateInRD(relatedData)

      if (findDate) {
        const options = {
          weekday: 'long',
          year: 'numeric',
          month: 'long',
          day: 'numeric'
        }
        const eventDate = new Date(findDate.value)
        return eventDate.toLocaleDateString('en-US', options)
      }
    },
    getDateValue(relatedData) {
      const findDate = this.findEventDateInRD(relatedData)

      if (findDate) {
        let dateDescription = ''
        const eventDate = new Date(findDate.value)

        if (eventDate > Date.now()) {
          const resultDate = eventDate - Date.now()
          const differenceInHours = Math.ceil(Math.abs(resultDate) / 36e5)
          const differenceInDays = Math.ceil(resultDate / (1000 * 60 * 60 * 24))
          const differenceInMins = Math.floor(resultDate / 1000 / 60)

          if (differenceInMins < 60) {
            dateDescription = `Happening in ${differenceInMins}) minute${
              differenceInMins <= 1 ? '' : 's'
            }`
          } else if (differenceInHours > 24) {
            dateDescription = `Happening in ${differenceInDays} day${
              differenceInDays === 1 ? '' : 's'
            }`
          } else {
            dateDescription = `Happening in ${differenceInHours} hour${
              differenceInHours === 1 ? '' : 's'
            }`
          }
        } else {
          dateDescription = 'Event finished'
        }
        return `${dateDescription}`
      } else {
        return 'No date found'
      }
    },
    getDateStatus(relatedData) {
      const result = this.getDateValue(relatedData)

      if (result.includes('Happpening') && result.includes('day')) {
        return 'event-happening'
      } else if (result.includes('Happening')) {
        return 'event-now'
      } else if (result.includes('finished')) {
        return 'event-finished'
      }
    },
    findEventDateInRD(relatedData) {
      return relatedData.find(data => data.data_type === 'Event Date')
    },
    sortedEventDates(eventList, mood) {
      return eventList.sort((a, b) => {
        const dateA = new Date(
          this.findEventDateInRD(a.properties.related_data).value
        )

        const dateB = new Date(
          this.findEventDateInRD(b.properties.related_data).value
        )

        if (mood === 'desc') {
          return dateA - dateB
        } else if (mood === 'asc') {
          return dateB - dateA
        }
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.event-list-container {
  overflow-y: auto;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  align-items: center;
  height: auto;
  max-height: 650px;
}

.event-card-container {
  width: 100%;
  display: flex;
  align-items: flex-start;
  border-bottom: 1px solid #ddd5cc;
  padding: 1em 0 1em 0.75em;
  cursor: pointer;

  .event-date {
    font: Medium 15px/20px Proxima Nova;
    letter-spacing: 0.75px;
    color: #707070;
    text-transform: uppercase;
  }

  .event-date-description {
    font: Bold 12px Proxima Nova;
    text-transform: uppercase;
    width: fit-content;
    padding: 0.25em;
    border-radius: 2rem;
    padding: 2px 5px;
    text-align: center;
  }

  .event-now {
    background: #155724;
    color: #fff;
  }

  .event-happening {
    background: #0c5460;
    color: #fff;
  }

  .event-finished {
    background-color: #721c24;
    color: #fff;
  }

  .event-title {
    font: Bold 16px/20px Proxima Nova;
    letter-spacing: 0.8px;
    color: #151515;
    margin: 0.25em 0;
  }

  .event-description {
    letter-spacing: 0.65px;
    color: #707070;
    padding: 5px;
  }

  button {
    align-self: center;
    background: #b47a2b 0% 0% no-repeat padding-box;
    border: 1px solid #eeeae5;
    border-radius: 2em;
    color: #fff;
    padding: 0.5em 1.5em;
    font-weight: bold;
  }

  .event-img {
    width: 135px !important;
    height: 135px;
    object-fit: cover;
    margin-right: 1em;
  }

  .event-details {
    display: flex;
    flex-direction: column;
    width: fit-content;
    max-width: 280px;
  }

  .no-event-container {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    width: 100%;
    padding: 1.5em 0;

    & > * {
      margin-bottom: 0.5em;
    }
  }

  &:hover {
    background-color: rgba(0, 0, 0, 0.05);
  }
}

.events-tags-container {
  display: flex;
  flex-wrap: wrap;
  width: inherit;
}

.events-tags-container span {
  flex: 0 0 auto;
  background: #ddd4c6;
  border-radius: 2rem;
  color: #707070;
  text-transform: uppercase;
  font: Bold 12px Proxima Nova;
  margin: 0.25em 0.5em 0.25em 0;
  padding: 2px 5px;
  text-align: center;

  &:hover {
    color: #fff;
    background-color: #545b62;
  }
}

@media (max-width: 992px) {
  .event-list-container {
    height: 100% !important;
    max-height: 100% !important;
  }
}
</style>
