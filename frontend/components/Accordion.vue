<template>
  <div class="accordion">
    <b-collapse id="outer-collapse" visible>
      <b-card>
        <p class="outer-text d-flex align-items-center justify-content-between">
          <span class="accordion-content">
            <span v-html="getContextData"> </span>
            <span
              class="accordion-toggle"
              @click="expandContent = !expandContent"
            >
              {{ `${expandContent ? 'collapse' : 'expand'}` }}
            </span>
          </span>
        </p>
      </b-card>
    </b-collapse>
  </div>
</template>

<script>
export default {
  props: {
    content: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      expandContent: false
    }
  },
  computed: {
    getContextData() {
      return this.expandContent
        ? this.content
        : `${this.content.substring(0, 100)} ...`
    }
  },
  watch: {
    expandContent(value) {
      if (value) {
        // Add Event Listener to drop-down
        this.$nextTick(() => {
          const dropdownList = ['grants-list-collapse', 'partner-list-collapse']

          dropdownList.forEach(element => {
            const grantsContainer = document.getElementById(element)
            grantsContainer.addEventListener('click', () => {
              const collapse = document.getElementById(`${element}-content`)
              const isBlock = collapse.style.display === 'block'
              collapse.style.display = isBlock ? 'none' : 'block'

              grantsContainer.querySelector(
                '.collapse-icon'
              ).innerHTML = isBlock ? '&#9658;' : '&#9660;'
            })
          })
        })
      }
    }
  },
  mounted() {}
}
</script>

<style>
.card-text span {
  display: inline-block;
  vertical-align: middle;
}
#outer-collapse .outer-text {
  padding: 0;
  margin: 0;
  color: var(--color-darkgray, #454545);
}
#outer-collapse > .card > .card-body {
  padding: 0.25rem 0;
}
#inner-collapse {
  margin: 0;
  padding: 0;
}
#inner-collapse .card {
  border: 0;
}
#inner-collapse .card-body {
  padding: 0;
  padding-top: 0.25rem;
}

#outer-collapse .card {
  border: 0;
  padding: 0;
}

.accordion-content {
  font-size: 16px;
  letter-spacing: 0.8px;
  margin: 0;
  padding: 0;
  color: #151515;
}

.accordion-content ul {
  padding-left: 20px;
}

.accordion-toggle {
  background-color: transparent;
  border: 0;
  text-decoration: underline;
  color: #c46257;
  font-weight: 800;
  cursor: pointer;
}
.accordion-toggle:hover {
  background-color: transparent;
  border: 0;
}

.collapse-item {
  cursor: pointer;
}

.collapse-item-content {
  display: none;
}
</style>
