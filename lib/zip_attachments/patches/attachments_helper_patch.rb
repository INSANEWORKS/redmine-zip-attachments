module ZipAttachments
  module Patches
    module AttachmentsHelperPatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          alias_method_chain :link_to_attachments, :zip_attachments
        end

      end

      module InstanceMethods

        def link_to_attachments_with_zip_attachments(container, options = {})
          default = link_to_attachments_without_zip_attachments(container, options)
          if ((Setting.plugin_zip_attachments || {})['enable_zip_attachments'])
            if container.attachments != []
              link_text = link_to(l(:label_zip_attachments), { controller: :attachments, action: :download_all, id: container.attachments[0].id }, class: 'icon icon-attachment in_link').html_safe
              if default.index('<!-- all_attaches -->')
                default = default.gsub('<!-- all_attaches -->', link_text).html_safe
              else
                default << '<br>'.html_safe
                default << link_text
                default << '<br>'.html_safe
              end
            end
          end

          return default
        end
      end
    end
  end
end

unless AttachmentsHelper.included_modules.include?(ZipAttachments::Patches::AttachmentsHelperPatch)
  AttachmentsHelper.send(:include, ZipAttachments::Patches::AttachmentsHelperPatch)
end

