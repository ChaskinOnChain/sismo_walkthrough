"use client";

import abi from "@/abi/abi";
import { errorsABI, formatError, signMessage } from "@/utils/misc";
import { ConnectButton } from "@rainbow-me/rainbowkit";
import {
  AuthType,
  SismoConnectButton,
  SismoConnectConfig,
} from "@sismo-core/sismo-connect-react";
import { waitForTransaction } from "@wagmi/core";
import { useEffect, useState } from "react";
import { useAccount, useContractWrite, usePrepareContractWrite } from "wagmi";

const sismoConnectConfig: SismoConnectConfig = {
  appId: "0x4895f3f40962d377e5119f5a5e67ca5d",
  vault: {
    impersonate: ["barmstrong.eth"],
  },
};

function Sismo() {
  const [responseBytes, setResponseBytes] = useState<string>("");
  const [error, setError] = useState<string>("");
  const [loading, setLoading] = useState<boolean>(false);
  const [minted, setMinted] = useState<boolean>(false);

  const { isConnected, address } = useAccount();

  const COINBASE_SHIELD_GROUP_ID = "0x842e4d1671d72526762a77ade9feb49a";

  const contractCallInputs = responseBytes
    ? {
        address: "0x190ab23feeabf635b9e1d7a29eef3f913dae109a" as `0x${string}`,
        abi: [...abi, ...errorsABI],
        functionName: "verifySismoConnectResponse",
        args: [responseBytes],
      }
    : {};

  const { config, error: wagmiSimulateError } =
    usePrepareContractWrite(contractCallInputs);
  const { writeAsync } = useContractWrite(config);

  useEffect(() => {
    if (!wagmiSimulateError) return;
    if (!isConnected) return;
    setError(formatError(wagmiSimulateError));
  }, [wagmiSimulateError, isConnected]);

  async function mintNft() {
    setLoading(true);
    try {
      const tx = await writeAsync?.();
      const txReceipt = tx && (await waitForTransaction({ hash: tx?.hash }));
      if (txReceipt?.status === "success") {
        setMinted(true);
      }
    } catch (error: any) {
      setError(formatError(error));
    } finally {
      setLoading(false);
    }
  }

  return (
    <div>
      {!isConnected && (
        <>
          <p>Please Connect:</p>
          <ConnectButton />
        </>
      )}
      {isConnected && !minted && !responseBytes && (
        <div>
          <p>Your NFT destination address is {address}</p>
          <div className="flex justify-center">
            <SismoConnectButton
              config={sismoConnectConfig}
              auths={[{ authType: AuthType.VAULT }]}
              signature={{ message: signMessage(address) }}
              onResponseBytes={(responseBytes: string) => {
                setResponseBytes(responseBytes);
              }}
              claims={[
                {
                  groupId: COINBASE_SHIELD_GROUP_ID,
                },
              ]}
              text={"Mint with Sismo"}
            />
          </div>
        </div>
      )}
      {isConnected && !minted && responseBytes && (
        <div className="text-center">
          <p>Your NFT destination address is {address}</p>
          <button
            className="border border-black rounded-md px-4 py-2"
            disabled={loading || Boolean(error)}
            onClick={mintNft}
          >
            {loading ? "Minting..." : "Mint"}
          </button>
        </div>
      )}
      {isConnected && minted && responseBytes && (
        <div className="text-center">
          <p>Congratulations!</p>
          <p>You&apos;ve just minted the NFT to {address}</p>
        </div>
      )}
      {isConnected && error && <p className="text-red-500">{error}</p>}
    </div>
  );
}

export default Sismo;
