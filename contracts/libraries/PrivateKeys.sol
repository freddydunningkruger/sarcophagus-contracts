// SPDX-License-Identifier: MIT
// taken from https://github.com/1Address/ecsol

pragma solidity ^0.6.0;

library PrivateKeys {
    uint256
        public constant gx = 0x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798;
    uint256
        public constant gy = 0x483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8;

    //
    // Based on the original idea of Vitalik Buterin:
    // https://ethresear.ch/t/you-can-kinda-abuse-ecrecover-to-do-ecmul-in-secp256k1-today/2384/9
    //

    function ecmulVerify(
        uint256 x1,
        uint256 y1,
        bytes32 scalar,
        bytes memory pubKey
    ) private pure returns (bool) {

            uint256 m
         = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141;
        address signer = ecrecover(
            0,
            y1 % 2 != 0 ? 28 : 27,
            bytes32(x1),
            bytes32(mulmod(uint256(scalar), x1, m))
        );
        address xyAddress = address(
            uint256(keccak256(pubKey)) &
                0x00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        );
        return xyAddress == signer;
    }

    function keyVerification(bytes32 privKey, bytes memory pubKey)
        public
        pure
        returns (bool)
    {
        return ecmulVerify(gx, gy, privKey, pubKey);
    }
}
