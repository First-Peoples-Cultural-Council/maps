<template>
  <div class="event-card-container">
    <span class="event-date">Saturday 21TH-2020 - 13:00</span>
    <h4 class="event-title">'Q'emcin 2 Rivers REmix 2019</h4>
    <div class="events-tags-container">
      <span>Artist</span>
      <span>Visual</span>
      <span>Painter</span>
      <span>Carver</span>
      <span>Carver</span>
    </div>
    <img src="@/assets/images/sample-dp.jpg" />
    <p class="event-description">
      Lorem ipsum dolor sit amet consectetur adipisicing elit. Ullam, unde qui
      quos iste praesentium laborum? Aliquam at fuga veniam quis id, neque quod
      alias obcaecati porro suscipit ullam ea temporibus!
    </p>
    <button>CHECK EVENT</button>
  </div>
</template>

<script>
export default {}
</script>

<style lang="scss" scoped>
.event-card-container {
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  margin: 1em 0 3em 0;

  .event-date {
    font: Medium 13px/20px;
    letter-spacing: 0.65px;
    color: #707070;
    text-transform: uppercase;
  }

  .event-title {
    font: Bold 20px/20px 'Faustina';
    letter-spacing: 1px;
    color: #454545;
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
  img {
    width: 100%;
    height: 250px;
    object-fit: contain;
  }
}

.events-tags-container {
  display: flex;
  flex-wrap: wrap;
  width: inherit;
  margin: 0.5em 0;
}

.events-tags-container span {
  flex: 0 1;
  background: #ddd4c6 0% 0% no-repeat padding-box;
  border-radius: 2rem;
  color: #707070;
  padding: 0.2em 0.5em;
  font-weight: bold;
  font-size: 0.8;
  margin: 0.25em 0.25em 0.25em 0;
  text-align: center;
}
</style>
