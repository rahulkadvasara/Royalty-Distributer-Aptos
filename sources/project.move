module MyModule::RoyaltyDistribution {

    // use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    // Struct to store creator's royalty percentage.
    struct Creator has store, key {
        royalty_percentage: u64, // Percentage (e.g., 10 for 10%)
    }

    // Register a creator with their royalty percentage.
    public fun register_creator(owner: &signer, percentage: u64) {
        let creator = Creator {
            royalty_percentage: percentage,
        };
        move_to(owner, creator);
    }

    // Distribute royalties when content is used.
    public fun distribute_royalty(user: &signer, creator_address: address, amount: u64) acquires Creator {
        let creator = borrow_global<Creator>(creator_address);
        let royalty_amount = (amount * creator.royalty_percentage) / 100;
        let payment = coin::withdraw<AptosCoin>(user, royalty_amount);
        coin::deposit<AptosCoin>(creator_address, payment);
    }
}
