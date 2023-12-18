// MyAgenda.res

module MyAgenda = {
  module Event = {
    type t = {
      name: string,
      startDate: Date.t,
      venue: string,
      price: float,
      affinity: API.Affinity.t,
    }
  }

  let oneRecommendationEveryDay = (~maxDistanceInKm, ~maxPrice) => {
    let currentLocation = API.Location.getCurrentLocation()

    // Get the events happening in the next few days
    let events = API.Event.nextEvents()

    // Filter events based on distance and price
    let filteredEvents =
      events
      |> Belt.Array.keep(event => distance == API.Location.distanceInKm(currentLocation, event.location),
      distance <= maxDistanceInKm && event.price <= maxPrice
      )

    // Sort events by startDate
    let sortedEvents =
      filteredEvents
      |> Belt.Array.sort((a, b) => Date.compare(a.startDate, b.startDate))

    switch Belt.Array.get(sortedEvents, 0) {
    | Some(recommendedEvent) => recommendedEvent
    | None => failwith("No events match the criteria.")
    }
  }
}
