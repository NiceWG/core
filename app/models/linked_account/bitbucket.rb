# == Schema Information
#
# Table name: linked_accounts
#
#  id               :integer          not null, primary key
#  person_id        :integer
#  type             :string
#  uid              :integer          not null
#  login            :string
#  first_name       :string
#  last_name        :string
#  email            :string
#  oauth_token      :string
#  oauth_secret     :string
#  permissions      :string
#  synced_at        :datetime
#  sync_in_progress :boolean          default(FALSE)
#  followers        :integer          default(0)
#  following        :integer          default(0)
#  created_at       :datetime
#  updated_at       :datetime
#  account_balance  :decimal(10, 2)   default(0.0)
#  anonymous        :boolean          default(FALSE), not null
#  company          :string
#  location         :string
#  bio              :text
#  cloudinary_id    :string
#  deleted_at       :datetime
#
# Indexes
#
#  index_linked_accounts_on_anonymous     (anonymous)
#  index_linked_accounts_on_email         (email)
#  index_linked_accounts_on_login         (login)
#  index_linked_accounts_on_person_id     (person_id)
#  index_linked_accounts_on_uid           (uid)
#  index_linked_accounts_on_uid_and_type  (uid,type) UNIQUE
#

class LinkedAccount::Bitbucket < LinkedAccount::Base

  def self.find_or_create_from_api_response(api_response)
    api_response = api_response.with_indifferent_access

    if (linked_account = where(login: api_response[:author_name]).first)
      linked_account.update_attribute(:image_url, api_response[:author_image_url])
      linked_account
    else
      create(
        login: api_response[:author_name],
        image_url: api_response[:author_image_url]
      )
    end
  end

end
