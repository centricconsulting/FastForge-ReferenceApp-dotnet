import React, { CSSProperties, memo } from "react";
import BeatLoader from "react-spinners/BeatLoader";

const style: CSSProperties = {
  display: "flex",
  justifyContent: "center",
  alignItems: "center",
  margin: "2px auto",
};
interface LoadingType {
  loading: boolean;
  size?: number;
  color?: string;
  override?: CSSProperties;
}

const _Loading: React.FC<LoadingType> = ({
  loading,
  size = 10,
  color = "white",
  override = style,
}) => {
  return (
    <>
      <BeatLoader
        color={color}
        loading={loading}
        cssOverride={override}
        size={size}
      />
    </>
  );
};

const Loading = memo(_Loading);

export default Loading;
