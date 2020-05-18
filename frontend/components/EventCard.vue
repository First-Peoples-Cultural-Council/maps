<template>
  <div class="event-card-container">
    <img src="@/assets/images/sample.png" />
    <div>
      <span class="event-date">MAY 23, 2020</span>
      <h4 class="event-title">'Q'emcin 2 Rivers REmix 2019</h4>
      <div class="events-tags-container">
        <span>Artist</span>
        <span>Visual</span>
        <span>Painter</span>
      </div>
    </div>

    <!-- <p class="event-description">
      Lorem ipsum dolor sit amet consectetur adipisicing elit. Ullam, unde qui
      quos iste praesentium laborum? Aliquam at fuga veniam quis id, neque quod
      alias obcaecati porro suscipit ullam ea temporibus!
    </p> -->
    <!-- <button>CHECK EVENT</button> -->
  </div>
</template>

<script>
export default {}
</script>

<style lang="scss" scoped>
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
  img {
    width: 135px;
    height: 135px;
    object-fit: cover;
    margin-right: 0.5em;
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
  flex: 0 1;
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
</style>
