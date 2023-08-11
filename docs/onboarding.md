# Setting Up User Onboarding

This guide will help you set up user onboarding in your application with RapidRails.

## 1. Enable Onboarding

In the [config/initializers/0_constants.rb](https://github.com/danielpaul/RapidRails/blob/main/config/initializers/0_constants.rb) file, set the ENABLE_ONBOARDING constant to true.

```
ENABLE_ONBOARDING = true
```

## 2. Define Required Fields

In the [app/models/concerns/user/onboarding.rb](https://github.com/danielpaul/RapidRails/blob/main/app/models/concerns/user/onboarding.rb) file, define the fields that are required for onboarding in the onboarding_required_fields method. Users will be redirected to the onboarding page if any of these fields are blank.

```
def onboarding_required_fields
  %w[full_name]
end
```

## 3. Update Onboarding View

In the app/views/onboarding/index.html.haml(https://github.com/danielpaul/RapidRails/blob/main/app/views/onboarding/index.html.haml) file, update the form to include the fields you defined in the previous step.

```
= form_with(model: current_user, url: onboarding_path, method: :patch, builder: RapidRailsFormBuilder, class: 'mt-5') do |f|
  .space-y-6
    = f.text_field :full_name, placeholder: "Your full name", required: true
    = f.button "Get started", class: "flex w-full justify-center btn-primary"
```

And thats it 🥳. Users will be redirected to the onboarding page if any of the onboarding fields you defined are blank.
