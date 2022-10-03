import React, { memo } from "react";
import { DeleteButton, CancelButton } from ".";
import ReactModal from "react-modal";

interface DeleteModalContentType {
  message: string;
  onSuccess?: () => any;
  title: string;
  onCancel?: () => any; 
  isOpen: boolean;
}

const _DeleteModalContent: React.FC<DeleteModalContentType> = ({
  onCancel,
  onSuccess,
  title,
  isOpen,
  message,
  ...rest
}) => {
  return ( 
   <>
  
 <ReactModal
        style={{
          content: {
            maxWidth: 500,
            maxHeight: 250,
            margin: "auto",
          },
        }}
        {...rest}
        isOpen={isOpen}
        onRequestClose={onCancel}
        ariaHideApp={false}
      >
        <div className="delete-modal__wrapper">
          <h5 className="title">{title}</h5>{" "}
          <h4 className="delete-modal__message">{message}</h4>
          <div className="delete-modal__button-wrapper  col-lg-12">
            <div className="delete-modal__button-wrapper--item col-lg-4 col-md-4">
              <CancelButton onClick={onCancel} title="Cancel" />
            </div>
            <div className="delete-modal__button-wrapper--item col-lg-8 col-md-8"> 
              <DeleteButton onClick={onSuccess} title="Delete" />
            </div>
          </div>
        </div>
        {/* {children} */}
      </ReactModal>
  
  
   </>
     
  );
};

const DeleteModalContent = memo(_DeleteModalContent);

export { DeleteModalContent };
