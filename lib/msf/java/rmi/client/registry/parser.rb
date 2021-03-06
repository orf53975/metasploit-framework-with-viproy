# -*- coding: binary -*-

module Msf
  module Java
    module Rmi
      module Client
        module Registry
          module Parser
            # Parses a java/rmi/registry/RegistryImpl_Stub#lookup() return value to find out
            # the remote reference information.
            #
            # @param return_value [Rex::Java::Serialization::Model::ReturnValue]
            # @return [Hash, NilClass] The remote interface information if success, nil otherwise
            def parse_registry_lookup_endpoint(return_value)
              values_size = return_value.value.length
              end_point_block_data = return_value.value[values_size - 2]
              unless end_point_block_data.is_a?(Rex::Java::Serialization::Model::BlockData)
                return nil
              end

              return_io = StringIO.new(end_point_block_data.contents, 'rb')

              reference = extract_reference(return_io)

              reference
            end

            # Parses a java/rmi/registry/RegistryImpl_Stub#list() return value to find out
            # the list of names registered.
            #
            # @param return_value [Rex::Java::Serialization::Model::ReturnValue]
            # @return [Array, NilClass] The list of names registered if success, nil otherwise
            def parse_registry_list(return_value)
              unless return_value.value[0].is_a?(Rex::Java::Serialization::Model::NewArray)
                return nil
              end

              unless return_value.value[0].type == 'java.lang.String;'
                return nil
              end

              return_value.value[0].values.collect { |val| val.contents }
            end
          end
        end
      end
    end
  end
end
