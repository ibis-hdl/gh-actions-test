// Copyright 2022 Olaf <ibis-hdl@users.noreply.github.com>.
// SPDX-License-Identifier: GPL-3.0-only

#include <fmt/format.h>
#include <fmt/ostream.h>

#include <iostream>
#include <string_view>

void print(std::ostream& os, std::string_view name) {
    os << fmt::format("Hello {0}!\n", name);
}


int main() {
    print(std::cout, "World");
    return 0;
}
