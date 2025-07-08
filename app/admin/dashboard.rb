# frozen_string_literal: true

ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    # Stat Cards
    # Since we are not compiling active admin assets and using activeadmin_assets gem, we cannot add
    # custom CSS classes that ActiveAdmin gem does not use. Need to do custom CSS for things we need.
    div class: "grid grid-cols-1 gap-6 mb-6", style: "grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));" do
      # Total Users Stat
      div class: "bg-white dark:bg-gray-800 rounded-lg border border-gray-300 dark:border-gray-700 p-4 text-center" do
        h3 class: "text-sm font-semibold text-gray-800 dark:text-gray-200" do
          "Total Users"
        end
        h6 class: "text-2xl font-bold text-gray-900 dark:text-gray-100 mt-2" do
          User.count
        end
      end

      # Recently Signed Up Users Count
      div class: "bg-white dark:bg-gray-800 rounded-lg border border-gray-300 dark:border-gray-700 p-4 text-center" do
        h3 class: "text-sm font-semibold text-gray-800 dark:text-gray-200" do
          "Recently Signed Up (Last 7 Days)"
        end
        h6 class: "text-2xl font-bold text-gray-900 dark:text-gray-100 mt-2" do
          User.where("created_at >= ?", 7.days.ago).count
        end
      end

      # Recently Onboarded Users Count
      div class: "bg-white dark:bg-gray-800 rounded-lg border border-gray-300 dark:border-gray-700 p-4 text-center" do
        h3 class: "text-sm font-semibold text-gray-800 dark:text-gray-200" do
          "Recently Onboarded (Last 7 Days)"
        end
        h6 class: "text-2xl font-bold text-gray-900 dark:text-gray-100 mt-2" do
          User.where("onboarding_completed_at >= ?", 7.days.ago).count
        end
      end

      # Deleted Users Count
      div class: "bg-white dark:bg-gray-800 rounded-lg border border-gray-300 dark:border-gray-700 p-4 text-center" do
        h3 class: "text-sm font-semibold text-gray-800 dark:text-gray-200" do
          "Deleted Users"
        end
        h6 class: "text-2xl font-bold text-gray-900 dark:text-gray-100 mt-2" do
          User.discarded.count
        end
      end
    end

    div class: "grid grid-cols-1 gap-6 md:grid-cols-2",
      style: "grid-template-columns: repeat(auto-fill, minmax(500px, 1fr));" do
      # Recently Signed Up Users Widget
      div class: "bg-white dark:bg-gray-800 rounded-lg border border-gray-300 dark:border-gray-700 overflow-hidden" do
        h3 class: "text-sm font-semibold text-gray-800 dark:text-gray-200 p-4 border-b border-gray-300 dark:border-gray-700" do
          "Recently Signed Up Users"
        end

        table_for User.order(created_at: :desc).limit(10),
          class: "table-auto w-full text-sm text-gray-600 dark:text-gray-300" do
          column(:id)
          column(:full_name)
          column(:email)
          column("Signed Up At") { |user| user.created_at.strftime("%Y-%m-%d %H:%M:%S") }
        end
      end

      # Recently Onboarded Users Widget
      div class: "bg-white dark:bg-gray-800 rounded-lg border border-gray-300 dark:border-gray-700 overflow-hidden" do
        h3 class: "text-sm font-semibold text-gray-800 dark:text-gray-200 p-4 border-b border-gray-300 dark:border-gray-700" do
          "Recently Onboarded Users"
        end

        table_for User.where.not(onboarding_completed_at: nil).order(onboarding_completed_at: :desc).limit(10),
          class: "table-auto w-full text-sm text-gray-600 dark:text-gray-300" do
          column(:id)
          column(:full_name)
          column(:email)
          column("Onboarded At") { |user| user.onboarding_completed_at.strftime("%Y-%m-%d %H:%M:%S") }
        end
      end
    end
  end
end
