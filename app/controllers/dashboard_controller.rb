class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @width = "narrow"

    set_meta_tags title: "Home"

    flash_message(
      :success,
      "Welcome to Rails Starter!",
      "Hope that this starter template gets your project up and running in no time.",
      now: true
    )

    flash_message(
      :notice,
      "This is a notice message.",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec aliquam a orci eu tristique. Suspendisse sit amet porttitor erat. Mauris luctus lacus eleifend ante fermentum finibus in ut odio. Proin vitae massa nisi. Praesent pharetra a nisl vitae dapibus. Nunc tempor elit vel leo suscipit, iaculis placerat nibh hendrerit. ",
      now: true
    )

    flash_message(
      :error,
      "This is an error message.",
      "Quisque at velit faucibus, euismod risus eget, semper libero. Praesent sit amet dolor leo. Mauris volutpat, libero non porttitor elementum, leo sem lacinia metus, vitae bibendum tellus mi non ipsum.",
      now: true
    )

    flash.now[:notice] = "This is an notice message."
    flash.now[:success] =
      "Fusce elementum porta ornare. Phasellus in ultricies nunc. Curabitur auctor urna sed erat consequat malesuada. Nunc nec lacus dapibus, hendrerit justo in, commodo neque. Ut malesuada nunc magna, vel eleifend sapien viverra nec. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas."
    flash.now[:error] = "This is an error message."
  end
end
