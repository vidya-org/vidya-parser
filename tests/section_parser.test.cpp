#include <catch/catch.hpp>

#include "../src/modseclog/section.hpp"

// clang-format off
// Example:
// --1dc01a0d-A--
// ...
// --1dc01a0d-Z--
//
// clang-format on

namespace vmod = vidya::modseclog;

SCENARIO( "Section parser", "[parser,section]" )
{
    GIVEN( "A string containing modsecurity log section A" )
    {
        const std::string log( "--1dc01a0d-A--\n" );

        WHEN( "the parser is invoked" )
        {
            vmod::Section section;
            auto itr_begin = log.begin();
            auto itr_end   = log.end();

            bool result = section.parse( itr_begin, itr_end );

            THEN( "result should be true" )
            {
                REQUIRE( result == true );
            }

            THEN( "iterators must differ" )
            {
                REQUIRE( itr_begin != log.begin() );
            }

            THEN( "should parse hash" )
            {
                REQUIRE( section.hash == "1dc01a0d" );
            }

            THEN( "should parse name" )
            {
                CAPTURE( section.hash );
                CAPTURE( section.name );
                REQUIRE( section.name == 'A' );
            }
        }
    }
}
