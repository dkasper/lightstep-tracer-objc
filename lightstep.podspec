Pod::Spec.new do |s|
  s.name             = "lightstep"
  s.version          = "3.0.8"
  s.summary          = "The LightStep Objective-C OpenTracing library."

  s.description      = <<-DESC
                       LightStep (lightstep.com) bindings for the OpenTracing API (opentracing.io).
                       DESC

  s.homepage         = "https://github.com/lightstep/lightstep-tracer-objc"
  s.license          = 'MIT'
  s.author           = { "LightStep" => "support@lightstep.com" }
  s.source           = { :git => "https://github.com/lightstep/lightstep-tracer-objc.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'

  # Directory where the generated files will be placed.
  genproto_dir = "Pod/Classes/protobuf"

  # Files generated by protoc
  s.subspec "Messages" do |ms|
    ms.source_files = "#{genproto_dir}/*.pbobjc.{h,m}", "#{genproto_dir}/**/*.pbobjc.{h,m}"
    ms.header_mappings_dir = genproto_dir
    ms.requires_arc = false
    # The generated files depend on the protobuf runtime.
    ms.dependency "Protobuf"
  end

  # Files generated by the gRPC plugin
  s.subspec "Services" do |ss|
    ss.source_files = "#{genproto_dir}/*.pbrpc.{h,m}", "#{genproto_dir}/**/*.pbrpc.{h,m}"
    ss.header_mappings_dir = genproto_dir
    ss.requires_arc = true
    # The generated files depend on the gRPC runtime, and on the files generated by protoc.
    ss.dependency "gRPC-ProtoRPC"
    ss.dependency "Protobuf"
    ss.dependency "#{s.name}/Messages"
  end

  # Do not include the gRPC/protobuf files which are handled by the subspecs below.
  s.source_files = 'Pod/Classes/*'
  s.requires_arc = true
  s.dependency "Protobuf"
  s.dependency "gRPC-ProtoRPC"
  s.dependency 'opentracing', '~>0.3.0'
  s.pod_target_xcconfig = {
    # This is needed by all pods that depend on Protobuf:
    'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS=1',
    # This is needed by all pods that depend on gRPC-RxLibrary:
    'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
  }

end
