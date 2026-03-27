comptime ExternalMutUnsafePointer[type: AnyType] = UnsafePointer[type, MutExternalOrigin]
comptime ExternalImmutUnsafePointer[type: AnyType] = UnsafePointer[type, ImmutExternalOrigin]

comptime c_void = NoneType
