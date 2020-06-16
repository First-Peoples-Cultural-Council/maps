<script>
import { Doughnut } from 'vue-chartjs'

export default {
  extends: Doughnut,
  props: {
    chartdata: {
      default: null,
      type: Object
    },
    options: {
      default: null,
      type: Object
    }
  },

  mounted() {
    this.renderChart(this.chartdata, this.options)
  }
}
</script>
<style></style>
