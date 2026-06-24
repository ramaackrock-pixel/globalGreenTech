import React, { createContext, useContext, useState } from "react";
import type { ReactNode } from "react";

interface SearchContextType {
    searchQuery: string;
    setSearchQuery: React.Dispatch<React.SetStateAction<string>>;
}


const SearchContext = createContext<SearchContextType | undefined>(undefined);

interface SearchContextProviderProps {
    children: ReactNode;
}

function SearchContextProvider({ children }: SearchContextProviderProps) {
    const [searchQuery, setSearchQuery] = useState("");

    return (
        <SearchContext.Provider
            value={{
                searchQuery,
                setSearchQuery,
            }}
        >
            {children}
        </SearchContext.Provider>
    );
}

function useSearch(): SearchContextType {
    const context = useContext(SearchContext);
    if (!context) {
        throw new Error("useSearch must be used within a SearchContextProvider");
    }

    return context;
}

export { SearchContextProvider, useSearch };