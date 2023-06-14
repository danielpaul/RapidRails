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
              hr
              div class: "text-xs font-semibold text-neutral-400 my-6" do
                menu_item[:title]
              end
            end

            if menu_item[:items] && menu_item[:items].any?
              ul class: "-mx-6 space-y-3 #{menu_item[:item_menu_classes]}", role: "list" do
                menu_item[:items].each do |item|
                  a_classes = "group flex gap-x-3 py-1 px-6 text-sm font-semibold hover:text-black dark:hover:text-white transition-colors duration-200"
                  icon_classes = "h-5 w-5 shrink-0"

                  if item[:active]
                    a_classes += " dark:bg-card-dark text-black dark:text-white border-l-4 border-primary"
                    icon_classes += " "
                  else
                    a_classes += " text-neutral-500 dark:text-neutral-300"
                    icon_classes += " "
                  end

                  li do
                    link_to(
                      item[:path],
                      class: a_classes
                    ) do
                      if item[:icon]
                        unsafe_raw heroicon(item[:icon], options: {class: icon_classes})
                      else
                        span class: "flex h-5 w-5 shrink-0 items-center justify-center rounded-lg border font-medium border-neutral-600 dark:border-white text-[0.625rem]" do
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
