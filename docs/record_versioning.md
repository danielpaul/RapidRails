# Record Versioning

The [PaperTrail](https://github.com/paper-trail-gem/paper_trail) gem is a Ruby on Rails plugin that helps you keep a record of how your data is changing. It creates a version history for your models, tracking changes to them over time. This can be useful for auditing or versioning purposes.

In this codebase, PaperTrail is used to add a object_changes column to the versions table. This column stores the changes diff for each update event.

```
class AddObjectChangesToVersions < ActiveRecord::Migration[7.0]
  TEXT_BYTES = 1_073_741_823

  def change
    add_column :versions, :object_changes, :text, limit: TEXT_BYTES
  end
end
```

This migration adds the object_changes column to the versions table, which is used by PaperTrail to store the changes made in each update event.

To use PaperTrail in your models, you would typically add a `has_paper_trail` declaration to the model.

```
class MyModel < ApplicationRecord
  has_paper_trail
end
```

This will enable versioning for instances of **MyModel**. You can then retrieve versions of an instance using the **versions** method.

```
instance = MyModel.find(id)
versions = instance.versions
```

Each version has various attributes like event **(create, update, destroy)**, object_changes (the changes made in this version), and `created_at` (when this version was created).

The `reify` method provided by the PaperTrail gem is used to recreate a previous version of an object. When called on a version instance, it returns an object of the original type as it was at the time of that version.

```
instance = MyModel.find(id)
previous_version = instance.versions.last
old_instance = previous_version.reify
```

In this example, old_instance is a **MyModel** object as it was at the time of the last version. Note that `reify` only returns an in-memory object and does not affect the database.

Since our controllers have a `current_user` method, you can easily track who is responsible for changes because of this controller callback that links the user to the version record.

```
class ApplicationController
  before_action :set_paper_trail_whodunnit
end
```

For further configuration, refer to the [paper trail documentation](https://github.com/paper-trail-gem/paper_trail#1e-configuration)
