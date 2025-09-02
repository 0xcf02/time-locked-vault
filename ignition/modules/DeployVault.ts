import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;

const VaultModule = buildModule("VaultModule", (m) => {
  // Set the unlock time to one year from now
  const unlockTimestamp = BigInt(
    Math.floor(Date.now() / 1000) + ONE_YEAR_IN_SECS
  );

  const unlockTimeArg = m.getParameter("_unlockTime", unlockTimestamp);

  const vault = m.contract("TimeLockedVault", [unlockTimeArg]);

  return { vault };
});

export default VaultModule;