@fieldwise_init
struct SameSite(Copyable, ImplicitlyCopyable, Writable):
    var value: UInt8

    comptime none = SameSite(0)
    comptime lax = SameSite(1)
    comptime strict = SameSite(2)

    comptime NONE = "none"
    comptime LAX = "lax"
    comptime STRICT = "strict"

    @staticmethod
    fn from_string(str: String) -> Optional[Self]:
        if str == SameSite.NONE:
            return materialize[SameSite.none]()
        elif str == SameSite.LAX:
            return materialize[SameSite.lax]()
        elif str == SameSite.STRICT:
            return materialize[SameSite.strict]()
        return None

    fn __eq__(self, other: Self) -> Bool:
        return self.value == other.value

    fn write_to[W: Writer, //](self, mut writer: W):
        if self.value == 0:
            writer.write(SameSite.NONE)
        elif self.value == 1:
            writer.write(SameSite.LAX)
        else:
            writer.write(SameSite.STRICT)

    fn __str__(self) -> String:
        return String.write(self)
