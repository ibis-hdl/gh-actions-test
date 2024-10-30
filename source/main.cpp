// Copyright 2022 Olaf <ibis-hdl@users.noreply.github.com>.
// SPDX-License-Identifier: GPL-3.0-only

#include <iostream>
#include <format>
#include <string_view>

void print(std::ostream& os, std::string_view name) {
    os << std::format("Hello {0}!\n", name);
}


int main() {
    print(std::cout, "World");
    return 0;
}
