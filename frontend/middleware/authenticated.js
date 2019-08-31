export default function({ store, redirect }) {
  // If the user is not authenticated
  console.log('Is Logged In?', store.state.user.isLoggedIn)
  if (!store.state.user.isLoggedIn) {
    return redirect(
      'https://fplm.auth.ca-central-1.amazoncognito.com/login?response_type=token&client_id=7rj6th7pknck3tih16ihekk1ik&redirect_uri=https://countable.ca'
    )
  }
}
