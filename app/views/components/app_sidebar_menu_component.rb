# frozen_string_literal: true

class AppSidebarMenuComponent < ApplicationComponent
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::Routes
  include ActionView::Helpers::OutputSafetyHelper
  include Heroicon::Engine.helpers

  def menu_items
    [
      {
        title: nil,
        item_menu_classes: nil,
        items: [
          {
            title: "Dashboard",
            icon: "academic-cap",
            path: root_path,
            active: true
          },
          {
            title: "Team",
            icon: "users",
            path: "#",
            active: false
          },
          {
            title: "Projects",
            icon: "folder",
            path: "#",
            active: false
          }
        ]
      },
      {
        title: "Your Team",
        item_menu_classes: "mt-2",
        items: [
          {
            title: "Heroicons",
            path: "#",
            active: false
          },
          {
            title: "Daniel",
            path: "#",
            active: false
          },
          {
            title: "Piya",
            path: "#",
            active: false
          }
        ]
      },
      {
        title: nil,
        classes: "mt-auto",
        items: [
          {
            title: "Settings",
            icon: "cog",
            path: "#",
            active: false
          }
        ]
      }
    ]
  end

  def template
    nav class: "flex flex-1 flex-col" do
      ul class: "flex flex-1 flex-col gap-y-7", role: "list" do
        menu_items.each do |menu_item|
          li class: menu_item[:classes] do
            if menu_item[:title]
              div class: "text-xs font-semibold leading-6 text-gray-400" do
                menu_item[:title]
              end
            end

            if menu_item[:items] && menu_item[:items].any?
              ul class: "-mx-2 space-y-1 #{menu_item[:item_menu_classes]}", role: "list" do
                menu_item[:items].each do |item|
                  li_classes = "text-gray-700 dark:text-gray-300 hover:text-primary hover:bg-gray-50 dark:hover:bg-card-dark group flex gap-x-3 rounded-md p-2 text-sm leading-6 font-semibold"
                  icon_classes = "h-6 w-6 shrink-0 text-gray-400 dark:text-gray-300 group-hover:text-primary"

                  if item[:active]
                    li_classes += " bg-gray-50 dark:bg-card-dark text-primary"
                    icon_classes += " text-primary"
                  end

                  li do
                    link_to(
                      item[:path],
                      class: li_classes
                    ) do
                      if item[:icon]
                        unsafe_raw heroicon(item[:icon], options: {class: icon_classes})
                      else
                        span class: "flex h-6 w-6 shrink-0 items-center justify-center rounded-lg border font-medium bg-white text-gray-400 border-gray-200 group-hover:border-primary group-hover:text-primary text-[0.625rem]" do
                          item[:title][0]
                        end
                      end
                      span class: "truncate" do
                        item[:title]
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
